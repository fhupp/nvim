{
  lib,
  stdenv,
  sqlite,
  git,
  neovim-unwrapped,
  wrapNeovimUnstable,
  neovimUtils,
}:
with lib;
{
  appName ? null,
  viAlias ? appName == null || appName == "nvim",
  vimAlias ? appName == null || appName == "nvim",
  plugins ? [ ],
  devPlugins ? [ ],
  ignoreConfigRegexes ? [ ],
  # Extra Runtime deps
  extraPackages ? [ ],
  extraLuaPackages ? p: [ ],
  extraPython3Packages ? p: [ ],
  #
  withPython3 ? true,
  withRuby ? false,
  withNodeJs ? false,
  withSqlite ? true,
  #
  wrapRc ? true,
}:
let
  defaultPlugin = {
    plugin = null;
    config = null;
    optional = false;
  };

  externalPackages = extraPackages ++ (optionals withSqlite [ sqlite ]);

  normalizePlugin = (pl: defaultPlugin // (if pl ? plugin then pl else { plugin = pl; }));

  normalizedPlugins = map normalizePlugin plugins;

  getRtpSrc = (
    src: name:
    lib.cleanSourceWith {
      inherit src;
      name = name;
      filter =
        path: tyoe:
        let
          srcPrefix = toString src + "/";
          relPath = lib.removePrefix srcPrefix (toString path);
        in
        lib.all (regex: builtins.match regex relPath == null) ignoreConfigRegexes;
    }
  );

  nvimRtpSrc = getRtpSrc ./nvim "nvim-rtp-src";

  nvimRtp = stdenv.mkDerivation {
    name = "nvim-rtp";
    src = nvimRtpSrc;

    buildPhase = ''
      mkdir -p $out/nvim
      mkdir -p $out/lua
      rm init.lua
    '';

    installPhase = ''
      cp -r lua $out/lua
      rm -r lua

      if [ -d "after" ]; then
        cp -r after $out/after
        rm -r after
      fi

      if [ ! -z "$(ls -A)" ]; then
          cp -r -- * $out/nvim
      fi
    '';
  };

  initLua = ''
    vim.opt.rtp:prepend('${nvimRtp}/lua')
  ''
  + (builtins.readFile ./nvim/init.lua)
  + optionalString (devPlugins != [ ]) (
    ''
      local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
      local dev_plugins_dir = dev_pack_path .. '/opt'
      local dev_plugin_path
    ''
    + strings.concatMapStringsSep "\n" (plugin: ''
      dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
      if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
        vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
        vim.cmd('!${git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
      end
      vim.cmd('packadd! ${plugin.name}')
    '') devPlugins
  )
  + ''
    vim.opt.rtp:prepend('${nvimRtp}/nvim')
    vim.opt.rtp:prepend('${nvimRtp}/after')
  '';

  extraMakeWrapperArgs =
    let
      sqliteLibExt = stdenv.hostPlatform.extensions.sharedLibrary;
      sqliteLibPath = "${sqlite.out}/lib/libsqlite3${sqliteLibExt}";
    in
    builtins.concatStringsSep " " (
      (optional (
        appName != "nvim" && appName != null && appName != ""
      ) ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [ ]) ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ (optional withSqlite ''--set LIBSQLITE_CLIB_PATH "${sqliteLibPath}"'')
      ++ (optional withSqlite ''--set LIBSQLITE "${sqliteLibPath}"'')
    );

  luaPackages = neovim-unwrapped.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;

  extraMakeWrapperLuaCArgs =
    optionalString (resolvedExtraLuaPackages != [ ])
      ''--suffix LUA_CPATH ";" "${
        concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages
      }"'';

  extraMakeWrapperLuaArgs =
    optionalString (resolvedExtraLuaPackages != [ ])
      ''--suffix LUA_PATH ";" "${
        concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages
      }"'';

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped {
    inherit
      extraPython3Packages
      withPython3
      withRuby
      withNodeJs
      viAlias
      vimAlias
      ;
    plugins = normalizedPlugins;

    luaRcContent = initLua;
    wrapperArgs = extraMakeWrapperArgs + " " + extraMakeWrapperLuaCArgs + " " + extraMakeWrapperLuaArgs;
    wrapRc = wrapRc;
  };

  isCustomAppName = appName != null && appName != "nvim";
in
neovim-wrapped.overrideAttrs (orig: {
  buildPhase =
    orig.buildPhase
    + lib.optionalString isCustomAppName ''
      mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
    '';
  meta.mainProgram = if isCustomAppName then appName else orig.meta.mainProgram;
})
