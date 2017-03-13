class FseventsTools < Formula
  desc "Command-line utilities for the FSEvents API"
  homepage "https://geoff.greer.fm/fsevents/"
  url "https://geoff.greer.fm/fsevents/releases/fsevents-tools-1.0.0.tar.gz"
  sha256 "498528e1794fa2b0cf920bd96abaf7ced15df31c104d1a3650e06fa3f95ec628"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e37f936608b8a9f36c4002144157999e4be7894c393de8bcaaab0030baa2e268" => :sierra
    sha256 "dbec9a1a0a249ce2646910d955af9d2c49a3fd57392ffc23df1bde17a55e0033" => :el_capitan
    sha256 "027f4fdf6175209725b2b80f981acb161d7f5c27add219e8a57ef392d4681d62" => :yosemite
  end

  head do
    url "https://github.com/ggreer/fsevents-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fork do
      sleep 2
      touch "testfile"
    end
    assert_match "notifying", shell_output("#{bin}/notifywait testfile")
  end
end
