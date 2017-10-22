class Pyyaml < Formula
  desc "YAML parser and emitter for Python"
  homepage "https://pyyaml.org/wiki/PyYAML"
  url "https://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz"
  sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"

  bottle do
    cellar :any
    sha256 "6604821c49ff17b3be30b3532fd16a9dd51e6d6dfc3cf73bf964ecd2bd2b9239" => :high_sierra
    sha256 "06f646741db71d76c0282a6574c13bb842f4771e3424d2a933171dccefd01e25" => :sierra
    sha256 "e98b1c4cc42b0ec3316866d6bc673d1053f842c62dce7576eb6df281730b6586" => :el_capitan
  end

  depends_on "libyaml"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    (testpath/"test.py").write <<~EOS
      #!/usr/bin/env python
      import os, sys, yaml.reader

      args = sys.argv

      try:
          stream = yaml.reader.Reader(args[1])
          while stream.peek() != u'\\0':
              stream.forward()
      except yaml.reader.ReaderError, exc:
            print exc
    EOS

    system "python", "test.py", test_fixtures("updater_fixture.yaml")
  end
end
