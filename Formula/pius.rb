class Pius < Formula
  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.2.tar.gz"
  sha256 "2a3a7f1c4ecaa7df46fa7c791387f2de5ef377a8f769fc325ba067d225ebfc79"
  revision 1

  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddf6b1286e96ae363cde114dc01ec69189525d432ac2a6fd5318cc4599015435" => :el_capitan
    sha256 "c75288a8bcdf0b153808de6aefc1ca36f5f00f3934c6a40cc61123a3962c65e1" => :yosemite
    sha256 "93c3e369ff367f4a04c040bdfba864dfb26ddab27a7dd5b2edbc2a6cd048839e" => :mavericks
  end

  depends_on :gpg

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    # Note: Upstream are planning to remove gpg1.x support in future.
    gpg = which("gpg2") || which("gpg")
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, gpg
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    The path to gpg is hardcoded in pius at compile time.
    You can specify a different path by editing ~/.pius:
      gpg-path=/path/to/gpg
    EOS
  end

  test do
    system "#{bin}/pius", "-T"
  end
end
