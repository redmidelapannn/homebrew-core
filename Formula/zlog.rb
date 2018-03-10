class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/lisongmin/zlog"
  url "https://github.com/lisongmin/zlog/archive/v1.2.12.1.tar.gz"
  sha256 "7127b4210728069667db39c6a163ae3fc070fe84a73bad642d5e707642b3b6d2"

  bottle do
    cellar :any
    sha256 "83e98de014eb835f2de68aa48d0c897992f1cff4e2e90e16e4f70d4b2974cd88" => :high_sierra
    sha256 "82a14b404863a7e4ab195d9a4dc5d792dc7dea2b319ba9a42084ce008421042b" => :sierra
    sha256 "8c6faef6be70005eadabbfe9e7702ff790e4956a5f9171f8925fdddd4343c39b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zlog-chk-conf", "-h"
  end
end
