# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  memo = {
    pname = "memo";
    version = "v0.0.17";
    src = fetchFromGitHub {
      owner = "mattn";
      repo = "memo";
      rev = "v0.0.17";
      fetchSubmodules = false;
      sha256 = "sha256-f6BHKA/G5WhYBh1ruCVb1BwVK6vvmC3XVakqnshFfmk=";
    };
  };
  pet = {
    pname = "pet";
    version = "v1.0.1";
    src = fetchFromGitHub {
      owner = "knqyf263";
      repo = "pet";
      rev = "v1.0.1";
      fetchSubmodules = false;
      sha256 = "sha256-B0ilobUlp6UUXu6+lVqIHkbFnxVu33eXZFf+F7ODoQU=";
    };
  };
}
