class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.io/"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  stable do
    url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.6/optipng-0.7.6.tar.gz"
    sha256 "4870631fcbd3825605f00a168b8debf44ea1cda8ef98a73e5411eee97199be80"

    # Patch for missing st_atim from struct stat on macOS 10.13.
    #
    # The block referencing st_atim used to be guarded by defined UTIME_NOW &&
    # defined UTIME_OMIT, but futimens(2) and utimensat(2) have been added in
    # macOS 10.13, and these macros are now defined.
    #
    # Issue reported and patch submitted to upstream on 2017-07-08:
    #   https://sourceforge.net/p/optipng/patches/9/
    # (Submitted patch is not exactly the same, because the code at question
    # has moved to another file in head.)
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a42e7b3/optipng/optipng-10.13-st_atim.patch"
      sha256 "89849450fa922af0c96e64e316b5f626ec46486cb5d59f85cd4716d2c5fa0173"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "385d4998a5f17ab958a61c24dc3b5c342cf4088d44fe55020c0de929b07c11c7" => :sierra
    sha256 "16b6d8d7f95a4bda691d01377392f4f1cb667becf49e8c009b446aea9390e2be" => :el_capitan
    sha256 "6d4791f910d8ce3c79880ce187859342a635cd0a5915341197324c87acd13bd8" => :yosemite
  end

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
  end
end
