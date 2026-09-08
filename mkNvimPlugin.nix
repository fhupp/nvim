{
  vimUtils,
}:
src: pname:
vimUtils.buildVimPlugin {
  inherit pname src;
  version = src.lastModifiedDate;
}
