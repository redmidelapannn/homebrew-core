class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7.tar.gz"
  sha256 "4d65f368b2d53ee2f93a25d5e9541ce27357f2b95e5e5afff210e0805042811e"
  revision 1
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    rebuild 2
    sha256 "30c9789398e78c45822b21e85e10da1cebf14f643a1c9a34b568ead2d7e22be5" => :mojave
    sha256 "02ed85a4e312579c0c98398769ffe97843c00d4a9d82633a890c668f62a954cc" => :high_sierra
    sha256 "d733821e0c19fd8f912ef66e5e4ad68f71eb86306fc96fe992f4d77c4351ced6" => :sierra
  end

  # The `faketime` command needs GNU `gdate` not BSD `date`.
  # See https://github.com/wolfcw/libfaketime/issues/158 and
  # https://github.com/Homebrew/homebrew-core/issues/26568
  depends_on "coreutils"

  depends_on :macos => :sierra

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end

  test do
    cp "/bin/date", testpath/"date" # Work around SIP.
    assert_match "1230106542",
      shell_output(%Q(TZ=UTC #{bin}/faketime -f "2008-12-24 08:15:42" #{testpath}/date +%s)).strip
  end
end
