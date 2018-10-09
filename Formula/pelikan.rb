class Pelikan < Formula
  desc "Production-ready cache services"
  homepage "https://twitter.github.io/pelikan"
  url "https://github.com/twitter/pelikan/archive/0.1.2.tar.gz"
  sha256 "c105fdab8306f10c1dfa660b4e958ff6f381a5099eabcb15013ba42e4635f824"
  head "https://github.com/twitter/pelikan.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c4a633a6fb8aee31471fa6e63243ab5ca76cc3f34f6410397b7c0ff008e31684" => :mojave
    sha256 "54d9e76bea6ebad59be71826c4a0cfd3a0ad694f555dc9dcc244e078a2552e5f" => :high_sierra
    sha256 "448bb518f3f987c9ba0f00c488ce2a9ca587e513485034761c9ac858bab0a83b" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pelikan_twemcache", "-c"
  end
end
