class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.8.2.tar.gz"
  sha256 "0963fbe9ee90acd1d15e9f09e826eaaf8ea0312e854803caf2db0a6dd40f4464"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2493586f43dff977af4d3f4eb42201a06289bc4e5b4a745abf9923766812b5d1" => :high_sierra
    sha256 "71733c22ab94922df57fc4158febe0edc9aa42efd73746c28072f41318b00fd2" => :sierra
    sha256 "469ee03f6a21ee6e72bc7f6f612faeac841c6d700650bf27033ce863a60c4431" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | #{bin}/lz4 | #{bin}/lz4 -d > #{output_file}"
    assert_equal output_file.read, input
  end
end
