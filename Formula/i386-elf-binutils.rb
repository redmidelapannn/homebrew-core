class I386ElfBinutils < Formula
  desc "FSF Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.tar.gz"
  sha256 "5a9de9199f22ca7f35eac378f93c45ead636994fc59f3ac08f6b3569f73fcf6f"
  depends_on "gettext" => :build
  depends_on "xz" => :build

  def install
    mkdir "binutils-build" do
      system "../configure", "--target=i386-elf",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/i386-elf-ar", "--version"
  end
end
