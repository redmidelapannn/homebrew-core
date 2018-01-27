class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/daq/daq-2.0.6.tar.gz"
  mirror "https://fossies.org/linux/misc/daq-2.0.6.tar.gz"
  sha256 "b40e1d1273e08aaeaa86e69d4f28d535b7e53bdb3898adf539266b63137be7cb"

  bottle do
    cellar :any
    rebuild 2
    sha256 "b362379a91291ae0488ee51b88ba0d9148aec18d433ab48c628e4e03475f8025" => :high_sierra
    sha256 "0c3545d561d29de9387cd90fd4a32d89c50a1451019fb50cc55f5e402e0dd279" => :sierra
    sha256 "e6f52725762deaf50f418040f06d3579fe68b4adbc3aff12d3459c61947c9f3c" => :el_capitan
  end

  # libpcap on >= 10.12 has pcap_lib_version() instead of pcap_version
  # Reported 8 Oct 2017 to bugs AT snort DOT org
  if MacOS.version >= :sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b345dac/daq/patch-pcap-version.diff"
      sha256 "20d2bf6aec29824e2b7550f32251251cdc9d7aac3a0861e81a68cd0d1e513bf3"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <daq.h>
      #include <stdio.h>

      int main()
      {
        DAQ_Module_Info_t* list;
        int size = daq_get_module_list(&list);
        daq_free_module_list(list, size);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-o", "test"
    system "./test"
  end
end
