class Libsmi < Formula
  desc "Library to Access SMI MIB Information"
  homepage "https://www.ibr.cs.tu-bs.de/projects/libsmi/"
  url "https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.4.8.tar.gz"
  mirror "https://ftp.mirrorservice.org/sites/download.salixos.org/i486/extra-14.2/source/libraries/libsmi/libsmi-0.4.8.tar.gz"
  sha256 "f048a5270f41bc88b0c3b0a8fe70ca4d716a46b531a0ecaaa87c462f49d74849"

  bottle do
    rebuild 2
    sha256 "eedd90ccd998ab16b6e21cb573797a51d4b614e1128d4e18c46249b17b610615" => :sierra
    sha256 "23e05d189930f4fe4de6303a961010e743d5e720a9ab1b0b8f0f80a98f7fe1c4" => :el_capitan
    sha256 "93e65cacdffae4f55364ef0f28740ff3ebb0dd26fb56731986a9ad8219a723ea" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/smidiff -V")
  end
end
