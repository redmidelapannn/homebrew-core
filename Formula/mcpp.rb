class Mcpp < Formula
  desc "Alternative C/C++ preprocessor"
  homepage "https://mcpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz"
  sha256 "3b9b4421888519876c4fc68ade324a3bbd81ceeb7092ecdbbc2055099fcb8864"

  bottle do
    cellar :any
    rebuild 2
    sha256 "67d3ca3414bf7e28d1434427a95e77c4bd8bcc6db944e99cc33627872613c2ab" => :sierra
    sha256 "35628f8e85ab5efb7519ed851e0dd3b68cca09741c874f1affcb1a236a5e2550" => :el_capitan
    sha256 "f3f1fc97f808eb9f9ac3760d680dd2b8675f6a75e468ba0418b80de86c26e824" => :yosemite
  end

  # stpcpy is a macro on macOS; trying to define it as an extern is invalid.
  # Patch from ZeroC fixing EOL comment parsing
  # https://forums.zeroc.com/forum/bug-reports/5445-mishap-in-slice-compilers?t=5309
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3fd7fba/mcpp/2.7.2.patch"
    sha256 "4bc6a6bd70b67cb78fc48d878cd264b32d7bd0b1ad9705563320d81d5f1abb71"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mcpplib"
    system "make", "install"
  end
end
