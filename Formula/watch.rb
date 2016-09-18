class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  head "https://gitlab.com/procps-ng/procps.git"

  stable do
    url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.12",
      :revision => "e0784ddaed30d095bb1d9a8ad6b5a23d10a212c4"

    # Upstream commit, which fixes missing HOST_NAME_MAX on BSD-y systems.
    # Commit subject is "watch: define HOST_NAME_MAX"
    patch do
      url "https://gitlab.com/procps-ng/procps/commit/e564ddcb01c3c11537432faa9c7a7a6badb05930.diff"
      sha256 "3a4664e154f324e93b2a8e453a12575b94aac9eb9d86831649731d0f1a7f869e"
    end
  end

  bottle do
    rebuild 1
    sha256 "a7bc22edae231ee607bb901dd414ca1aa4b216548f99d58ef0a30b96ecc9438b" => :sierra
    sha256 "93daf81138422fb96350efc4fa1a6073b30b9b625d34e6cea2126b63af9d02d6" => :el_capitan
    sha256 "31b517c67875cbb8ca8bd8126af66561a8df0f61bee955ffdeac3eeb6021ec12" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"

  conflicts_with "visionmedia-watch"

  def install
    # Prevents undefined symbol errors for _libintl_gettext, etc.
    # Reported 22 Jun 2016: https://gitlab.com/procps-ng/procps/issues/35
    ENV.append "LDFLAGS", "-lintl"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
