class Aacgain < Formula
  desc "AAC-supporting version of mp3gain"
  homepage "http://aacgain.altosdesign.com/"
  # This server will autocorrect a 1.9 url back to this 1.8 tarball.
  # The 1.9 version mentioned on the website is pre-release, so make
  # sure 1.9 is actually out before updating.
  # See: https://github.com/Homebrew/homebrew/issues/16838
  url "http://aacgain.altosdesign.com/alvarez/aacgain-1.8.tar.bz2"
  sha256 "2bb8e27aa8f8434a4861fdbc70adb9cb4b47e1dfe472910d62d6042cb80a2ee1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2d7ea587b06feb7ccb4f6dfaee3a6d7b329e041cc80af969afb8b5d1631997e8" => :sierra
    sha256 "8a94784316a706f327b0a8374d83a40a11c99f18fc6dca39b822aaf0365177a7" => :el_capitan
    sha256 "9c56e7b68d4659bb7ed92e1b663d127a24e1ecebd206573d7f643ba36ea5e170" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # aacgain modifies files in-place
    # See: https://github.com/Homebrew/homebrew/pull/37080
    cp test_fixtures("test.m4a"), "test.m4a"
    system bin/"aacgain", "test.m4a"
  end
end
