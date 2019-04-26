class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://seladb.github.io/PcapPlusPlus-Doc"
  url "https://github.com/seladb/PcapPlusPlus/archive/v19.04.tar.gz"
  sha256 "0b44074ebbaaa8666e16471311b6b99b0a5bf52d16bbe1452d26bacecfd90add"

  bottle do
    cellar :any_skip_relocation
    sha256 "707ef5482d7c3c0d496de30b403a8220e57bbeae3d3b6cb82b209bda46af9464" => :mojave
    sha256 "39f4d11b06369fb835a355e413c021df31360b31f78d3a1ad7f2eee4bbd4612c" => :high_sierra
    sha256 "24a9ae39631539a93ef52ca0bedc7eb6f5596ed171daed3eb46c05e2b59b84ba" => :sierra
  end

  def install
    sdk_path_cmd = "xcrun --show-sdk-path"
    sdk_path_relace = "-I" + `#{sdk_path_cmd}`.chomp
    inreplace "mk/PcapPlusPlus.mk.macosx", "-I", sdk_path_relace
    system "./configure-mac_os_x.sh", "--install-dir", prefix

    # library requires to run 'make all' and
    # 'make install' in two separate commands.
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "stdlib.h"
      #include "PcapLiveDeviceList.h"
      int main() {
        const std::vector<pcpp::PcapLiveDevice*>& devList =
          pcpp::PcapLiveDeviceList::getInstance().getPcapLiveDevicesList();
        if (devList.size() > 0) {
          if (devList[0]->getName() == NULL)
            return 1;
          return 0;
        }
        return 0;
      }
    EOS

    (testpath/"Makefile").write <<~EOS
      include #{etc}/PcapPlusPlus.mk
      all:
      \tg++ $(PCAPPP_BUILD_FLAGS) $(PCAPPP_INCLUDES) -c -o test.o test.cpp
      \tg++ -L/usr/local/Cellar/pcapplusplus/19.04/lib -o test test.o $(PCAPPP_LIBS)
    EOS

    system "cat", "#{etc}/PcapPlusPlus.mk"
    system "make", "all"
    system "./test"
  end
end
