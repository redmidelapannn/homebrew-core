class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"

  bottle do
    rebuild 1
    sha256 "501b84cf0440fd53b9cfb5309fdc71c63a144e2ffcd4fe3ee5b8db90493a833c" => :high_sierra
    sha256 "d37814111a53f3f69af2db4a86127c0b0d001a4b249bdfeefe84286aae557642" => :sierra
    sha256 "3434afd72f6576caa7cc3830004d7628d9e2ec328c68c5c942befd753e019989" => :el_capitan
  end

  depends_on "mad"
  depends_on "libid3tag"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6c5992c/madplay/patch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    # Avoid "error: CPU you selected does not support x86-64 instruction set"
    args << "--build=#{Hardware::CPU.arch_64_bit}" if MacOS.prefer_64_bit?
    system "./configure", *args
    system "make", "install"
  end
end
