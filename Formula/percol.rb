class Percol < Formula
  desc "Interactive grep tool"
  homepage "https://github.com/mooz/percol"
  url "https://github.com/mooz/percol/archive/v0.2.1.tar.gz"
  sha256 "75056ba1fe190ae4c728e68df963c0e7d19bfe5a85649e51ae4193d4011042f9"
  head "https://github.com/mooz/percol.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "cmigemo" do
    url "https://files.pythonhosted.org/packages/2f/e4/374df50b655e36139334046f898469bf5e2d7600e1e638f29baf05b14b72/cmigemo-0.1.6.tar.gz"
    sha256 "7313aa3007f67600b066e04a4805e444563d151341deb330135b4dcdf6444626"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"expect-script").write <<-EOS.undent
      spawn #{bin}/percol --query=Homebrew #{HOMEBREW_PREFIX}/README.md
      expect "QUERY> Homebrew"
    EOS
    assert_match "Homebrew", shell_output("/usr/bin/expect -f expect-script")
  end
end
