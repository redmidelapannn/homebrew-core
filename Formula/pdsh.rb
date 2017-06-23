class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://code.google.com/p/pdsh/"
  url "https://github.com/grondo/pdsh/releases/download/pdsh-2.32/pdsh-2.32.tar.gz"
  sha256 "e1f1e5421d144a80ffc93fbdd5ace739fc39eb3219bd71d2ac06cf436428ef57"

  bottle do
    sha256 "0ae68818c7d5215a7a037c44681c514bd676d3db5d47fa5ea909321afb0c2d6a" => :sierra
    sha256 "3cc2ef3a642a9a8edb6a859aa55f7f767a6a1d3e6f6fd16fb79f0f597ae78c18" => :el_capitan
    sha256 "141ace11fbd043f0e29e53362d0bcb37647342795d1d88f631a5822f035f3d43" => :yosemite
  end

  option "without-dshgroups", "This option should be specified to load genders module first"

  depends_on "readline"
  depends_on "genders" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssh
      --without-rsh
      --with-nodeupdown
      --with-readline
      --without-xcpu
    ]

    args << "--with-genders" if build.with? "genders"
    args << (build.without?("dshgroups") ? "--without-dshgroups" : "--with-dshgroups")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
