class Far2l < Formula
  desc "Linux port of FAR v2"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/alpha-02nov18.tar.gz"
  version "0.2-alpha"
  sha256 "971d170698d9567d28c547ba5d49234f6d0f9e5b1dece0ab366037daea87e675"
  head "https://github.com/elfmz/far2l.git"

  bottle do
    cellar :any
    sha256 "de7fdd69209432ac70d3b6c6378c95ebdd3b7dbb06cd6e78d123c8fc09aced68" => :mojave
    sha256 "a647c1037126f3c0c8b301cc6053dd7a75396e4bf09d6459f05ba4cb2b8d6f49" => :high_sierra
    sha256 "bc13c4e2905d8c8b9ae3c1e1b118f7f4952ba54868d3d0ce3759f397b50e00f1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gawk"
  depends_on "glib"
  depends_on "pkg-config"
  depends_on "wget"
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install", "DESTDIR=#{prefix}"
    mkdir_p bin.to_s
    (bin/"far2l").write <<~EOS
      #!/usr/bin/env bash
      "#{prefix}/usr/bin/far2l"
    EOS
  end
end
