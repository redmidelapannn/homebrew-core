class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://www.mplayerhq.hu/"
  url "https://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz"
  sha256 "3ad0846c92d89ab2e4e6fb83bf991ea677e7aa2ea775845814cbceb608b09843"

  bottle do
    rebuild 1
    sha256 "a73ba8f73480b9041b82fa6a2ce3efab352ecaddb928b1d5ff62797dd386d996" => :sierra
    sha256 "16d3a34db53def2912a7b37d2cf5aab052713c73eca923c67ae962375607ba04" => :el_capitan
    sha256 "fa6e7561cf3084e788565ec7af937754eb70664a560ee8307f8f4b379a71ef82" => :yosemite
  end

  head do
    url "svn://svn.mplayerhq.hu/mplayer/trunk"
    depends_on "subversion" => :build if MacOS.version <= :leopard

    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    patch :DATA
  end

  depends_on "yasm" => :build
  depends_on "libcaca" => :optional

  unless MacOS.prefer_64_bit?
    fails_with :clang do
      build 211
      cause "Inline asm errors during compile on 32bit Snow Leopard."
    end
  end

  def install
    # It turns out that ENV.O1 fixes link errors with llvm.
    ENV.O1 if ENV.compiler == :llvm

    # we disable cdparanoia because homebrew's version is hacked to work on macOS
    # and mplayer doesn't expect the hacks we apply. So it chokes. Only relevant
    # if you have cdparanoia installed.
    # Specify our compiler to stop ffmpeg from defaulting to gcc.
    args = %W[
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-cdparanoia
      --prefix=#{prefix}
      --disable-x11
    ]

    args << "--enable-caca" if build.with? "libcaca"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end

__END__
diff --git a/configure b/configure
index addc461..3b871aa 100755
--- a/configure
+++ b/configure
@@ -1517,8 +1517,6 @@ if test -e ffmpeg/mp_auto_pull ; then
 fi
 
 if test "$ffmpeg_a" != "no" && ! test -e ffmpeg ; then
-    echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-    read tmp
     if ! git clone -b $FFBRANCH --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg ; then
         rm -rf ffmpeg
         echo "Failed to get a FFmpeg checkout"
