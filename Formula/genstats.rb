class Genstats < Formula
  desc "Generate statistics about stdin or textfiles"
  homepage "https://www.vanheusden.com/genstats/"
  url "https://www.vanheusden.com/genstats/genstats-1.2.tgz"
  sha256 "f0fb9f29750cdaa85dba648709110c0bc80988dd6a98dd18a53169473aaa6ad3"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4cfff2e0fba0e4a790dfcdb09e501c54776db3f0da22c8ee1a19a0daf9206170" => :el_capitan
    sha256 "35ea044a32b2d44d12033d2c49bb3c9cd6954f0240d6e2a5e7c66607028fe38d" => :yosemite
    sha256 "1171de1f9ff26945954bb4ee7238e04113dfd14334b895b0464789b0fc1af459" => :mavericks
  end

  depends_on :macos => :lion # uses strndup

  def install
    # Tried to make this a patch.  Applying the patch hunk would
    # fail, even though I used "git diff | pbcopy".  Tried messing
    # with whitespace, # lines, etc.  Ugh.
    inreplace "br.cpp", /if \(_XOPEN_VERSION >= 600\)/, "if (_XOPEN_VERSION >= 600) && !__APPLE__"

    system "make"
    bin.install("genstats")
    man.install("genstats.1")
  end

  test do
    system "#{bin}/genstats -h | grep folkert@vanheusden.com"
  end
end
