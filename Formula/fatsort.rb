class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://github.com/sh-khashimov/fatsort/archive/master.tar.gz"
  version "1.6.2"
  sha256 "394aafccd8df0b4126e5029f0f507ad35a4e1cd22e3ca8e3b8e5ca3dac16482c"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ae5393573f9b8d0e0a3a1fa1dfbbd0842fcad9ae83091a4933b8feb7d59bbb0" => :catalina
    sha256 "1ac16ac70d2bdba966f6303e937ed5ccbab64b3ead6d96b3ddecffe8a8af8138" => :mojave
    sha256 "67e6509d5d445e05536c880ab548bd50660c52dc4e4f040f317d4f50c4de48ec" => :high_sierra
  end

  depends_on "help2man"

  def install
    cd "src" do
      system "make", "CC=#{ENV.cc}"
      bin.install "fatsort"
    end
  end

  test do
    system "#{bin}/fatsort", "--version"
  end
end
