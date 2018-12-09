class Squash < Formula
  desc "Compression abstraction library and utilities"
  homepage "https://quixdb.github.io/squash/"
  url "https://github.com/Demacr/squash/releases/download/v0.8.0/squash.zip"
  sha256 "4ea9be3c74d611e05a7975ba65acd511196ba0283fcf327523a5c620cc195f00"
  bottle do
    sha256 "a5ca100b0573d83f4f5a713e1f4c6bbdb5f7e234c9252930ebc055a23e8f4339" => :mojave
    sha256 "28bf2458c5ec4525b870fb8182d682a44cc044579ea3e318042d6d28fe9057f9" => :high_sierra
    sha256 "afad0695c27d0d093966874c9af9043a412ce5b8aa83703511004f31dc68c8b6" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "false"
  end
end
