class Tmpwatch < Formula
  desc "Find and remove files not accessed in a specified time"
  homepage "https://pagure.io/tmpwatch"
  url "https://releases.pagure.org/tmpwatch/tmpwatch-2.11.tar.bz2"
  sha256 "93168112b2515bc4c7117e8113b8d91e06b79550d2194d62a0c174fe6c2aa8d4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "611a4b897c21eba33ef3d9bb0fdc2efbc0acc467239bd3cfe7880a56c388ba76" => :sierra
    sha256 "0d8b0435b8f13b7ae951f74e215431caed05d5fd4b999e472bd59ea0d43f67a4" => :el_capitan
    sha256 "01f30b4a30326dc7eae7b949ecbc45d506f7d854dac6cfcf4cdb465c24dac235" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test" do
      touch %w[a b c]
      ten_minutes_ago = Time.new - 600
      File.utime(ten_minutes_ago, ten_minutes_ago, "a")
      system "#{sbin}/tmpwatch", "2m", Pathname.pwd
      assert_equal %w[b c], Dir["*"]
    end
  end
end
