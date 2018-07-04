class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.tar.xz"
  sha256 "6c7397abc764e32e8159c2e96042874a190303e77adceb4ac5bd502a272a4734"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a48ea5eb566e07c041793270b2683ddf71e62311b9adffa9f8ba39043cd9275e" => :high_sierra
    sha256 "d03493419b6f3ac4da4698444589c3d3fec8991db74cffc320800eddcd272150" => :sierra
    sha256 "6dcdce8a924530e57b86069a6edeef486886362e6b4c09ddc19d25c00d9481e0" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-ipcs",        # does not build on macOS
                          "--disable-ipcrm",       # does not build on macOS
                          "--disable-wall",        # already comes with macOS
                          "--disable-libuuid",     # conflicts with ossp-uuid
                          "--disable-libsmartcols" # macOS already ships 'column'

    system "make", "install"

    # Remove binaries already shipped by macOS
    %w[cal col colcrt colrm hexdump logger nologin look mesg more renice rev ul whereis].each do |prog|
      rm_f bin/prog
      rm_f sbin/prog
      rm_f man1/"#{prog}.1"
      rm_f man8/"#{prog}.8"
      rm_f share/"bash-completion"/"completions"/prog
    end
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
