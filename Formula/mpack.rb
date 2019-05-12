class Mpack < Formula
  desc "MIME mail packing and unpacking"
  homepage "https://web.archive.org/web/20190220145801/ftp.andrew.cmu.edu/pub/mpack/"
  url "https://web.archive.org/web/20190220145801/ftp.andrew.cmu.edu/pub/mpack/mpack-1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/mpack-1.6.tar.gz"
  sha256 "274108bb3a39982a4efc14fb3a65298e66c8e71367c3dabf49338162d207a94c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4e9fa6bb6ed44e500daae00d3211635b45842edb8ff3fd88e79a4f397ee5b879" => :mojave
    sha256 "51f4bd4480a9d00cf001861c6ddd6d198b65756bf100082d5545aa33cfdd29b3" => :high_sierra
    sha256 "8ec5211543f8310d2fbdffd8aae93048fdaf863df3f813b9ace885b68cfdf78a" => :sierra
  end

  # Fix missing return value; clang refuses to compile otherwise
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1ad38a9c/mpack/uudecode.c.patch"
    sha256 "52ad1592ee4b137cde6ddb3c26e3541fa0dcea55c53ae8b37546cd566c897a43"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
