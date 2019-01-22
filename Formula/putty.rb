class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.70/putty-0.70.tar.gz"
  sha256 "bb8aa49d6e96c5a8e18a057f3150a1695ed99a24eef699e783651d1f24e7b0be"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9aab5a1cefee5bc18eed61f8ad791d3e8b73838c256f6b7ce6daa70adad20127" => :mojave
    sha256 "09077001137389f5708faa69aee786292a4f84e3400633a71b32ac0a288eb3f8" => :high_sierra
    sha256 "3e9fa7b2cf71cde38657c418c767591e6ccea48453f5317144e1570ac9b1cabe" => :sierra
  end

  head do
    url "https://git.tartarus.org/simon/putty.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "halibut" => :build
  end

  depends_on "pkg-config" => :build

  conflicts_with "pssh", :because => "both install `pscp` binaries"

  def install
    if build.head?
      system "./mkfiles.pl"
      system "./mkauto.sh"
      system "make", "-C", "doc"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-gtktest
      --without-gtk
    ]

    system "./configure", *args

    build_version = build.head? ? "svn-#{version}" : version
    system "make", "VER=-DRELEASE=#{build_version}"

    bin.install %w[plink pscp psftp puttygen]

    cd "doc" do
      man1.install %w[plink.1 pscp.1 psftp.1 puttygen.1]
    end
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system "./command.sh"
    assert_predicate testpath/"test.key", :exist?
  end
end
