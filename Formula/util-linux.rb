class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "45599b20d5a9cb95aa748534e75160eaa4c454b66c5a00785be5c55e48e4ebf9" => :mojave
    sha256 "ae056d73b603286a25829bd61989d39cc7601345a7903c42b82545e6d8cf9e9e" => :high_sierra
    sha256 "fa9c22de36208292cb93c7bb404b0013cefae931a13abb9060973809356ce02d" => :sierra
    sha256 "49254e1e5f6bd36134611e821395cdc1146dbcdbf6d1f784b137ad8f41246246" => :el_capitan
  end

  conflicts_with "rename", :because => "both install `rename` binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-ipcs",        # does not build on macOS
                          "--disable-ipcrm",       # does not build on macOS
                          "--disable-wall",        # already comes with macOS
                          "--disable-libuuid",     # conflicts with ossp-uuid
                          "--disable-libsmartcols" # macOS already ships 'column'

    system "make", "install"

    # Remove binaries already shipped by macOS
    %w[cal col colcrt colrm getopt hexdump logger nologin look mesg more renice rev ul whereis].each do |prog|
      rm_f bin/prog
      rm_f sbin/prog
      rm_f man1/"#{prog}.1"
      rm_f man8/"#{prog}.8"
      rm_f share/"bash-completion/completions/#{prog}"
    end

    # install completions only for installed programs
    Pathname.glob("bash-completion/*") do |prog|
      if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
        bash_completion.install prog
      end
    end
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
