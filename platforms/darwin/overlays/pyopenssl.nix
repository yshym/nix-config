self: super:

{
  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      pyopenssl = python-super.pyopenssl.overrideAttrs (_: {
        meta.broken = false;
      });
    };
  };
}
