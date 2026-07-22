{
  lib,
  fetchPypi,
  python3Packages,
}:

let
  cloudinary = python3Packages.buildPythonPackage rec {
    pname = "cloudinary";
    version = "1.45.0";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-cRQEv734eWWvvv23R654oDGItROEbMywwfioxhLjdbo=";
    };

    build-system = [ python3Packages.setuptools ];

    dependencies = with python3Packages; [
      certifi
      six
      urllib3
    ];

    doCheck = false;
    pythonImportsCheck = [ "cloudinary" ];

    meta = {
      description = "Python SDK for Cloudinary";
      homepage = "https://github.com/cloudinary/pycloudinary";
      license = lib.licenses.mit;
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "cloudinary-cli";
  version = "1.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "cloudinary_cli";
    inherit version;
    hash = "sha256-wpsHio2qZti0iuXuT+nC7FknQ8DCUUvICzv5yUcqtjo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '    setup_requires=["pytest-runner"],' ""
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    click
    click-log
    cloudinary
    docstring-parser
    filelock
    jinja2
    pygments
    requests
    urllib3
    zipp
  ];

  doCheck = false;
  pythonImportsCheck = [ "cloudinary_cli" ];

  meta = {
    description = "Command line interface for Cloudinary with full API support";
    homepage = "https://github.com/cloudinary/cloudinary-cli";
    license = lib.licenses.mit;
    mainProgram = "cld";
  };
}
