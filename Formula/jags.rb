class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.0.tar.gz"
  sha256 "8ac5dd57982bfd7d5f0ee384499d62f3e0bb35b5f1660feb368545f1186371fc"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "92576b5ab06d1e422640eea9dae555a24c54ce796ae01429ca8b6964cd60d25c" => :high_sierra
    sha256 "42f118fce9a017d7e27929bb3f8c4913ca1b48ad8d3e3fffa3575a2042ec619d" => :sierra
    sha256 "19df55a514a7638d33531aec6226b992c309390ff9188d7fa85845efa266c219" => :el_capitan
  end

  depends_on "libtool"
  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"model.bug").write <<~EOS
      data {
        obs <- 1
      }
      model {
        parameter ~ dunif(0,1)
        obs ~ dbern(parameter)
      }
    EOS
    (testpath/"script").write <<~EOS
      model in model.bug
      compile
      initialize
      monitor parameter
      update 100
      coda *
    EOS
    system "#{bin}/jags", "script"
  end
end
