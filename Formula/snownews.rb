class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/kouya/snownews"
  url "https://github.com/kouya/snownews/archive/1.6.10.tar.gz"
  sha256 "8c78067aef75e283df4b3cca1c966587b6654e9e84a3e6e5eb8bdd5829799242"

  bottle do
    rebuild 1
    sha256 "c7aff6cdbbf7c7b739f471054d1417a1f31081d0b7564ad8a03aea65b0070665" => :mojave
    sha256 "db1aba4f62164f791871734e4ebf61b0e24299c80119f3f6368db96d5abf7be8" => :high_sierra
    sha256 "c93fa5fd192d423e7bd9a041dc497025a6daed05efa1bb9ff6fa0fe423e791d4" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  uses_from_macos "libxml2"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "./configure", "--prefix=#{prefix}"

    # Must supply -lz because configure relies on "xml2-config --libs"
    # for it, which doesn't work on OS X prior to 10.11
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags} -L#{Formula["openssl"].opt_lib} -lz",
           "CC=#{ENV.cc}", "INSTALL=ginstall"
  end

  test do
    system bin/"snownews -V"
  end
end
