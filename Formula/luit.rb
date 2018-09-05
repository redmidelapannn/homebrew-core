class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20180628.tgz"
  sha256 "7b84f63072589e9b03bb3e99e01ef344bb37793b76ad1cbb7b11f05000d64844"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f1a9168748b98054f58a5e40126f6bf093601863de25e0e08fabdd881ffa9c7e" => :mojave
    sha256 "022703987e34437d86d7c98feb31a51b9271a72f77e58f485137452c51425a49" => :high_sierra
    sha256 "99f628aecf5359d0bd1eae39e0548072404c3a6ebde8134c7b68efae31730d78" => :sierra
    sha256 "687389dddd436895f9db31522afcaa6e37bd55a6832705e95cb8d082c0b00b19" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-encodings-dir=auto"
    system "make", "install"
  end

  test do
    require "pty"
    PTY.spawn(bin/"luit", "-encoding", "GBK", "ls") do |r, _w, _pid|
    end
  end
end
