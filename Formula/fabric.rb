class Fabric < Formula
  desc "Library and command-line tool for SSH"
  homepage "http://www.fabfile.org"
  url "https://github.com/fabric/fabric/archive/1.12.0.tar.gz"
  sha256 "c58d51963b77b0e55aa7ebd800b86217851a40d8abf3247a2a0c358a226344ff"
  head "https://github.com/fabric/fabric.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "53ad4dd2d590dfd27100652955eb1504f6eac97024d3736c354364bef1586a34" => :sierra
    sha256 "1c6f8669de9b7eab442f0e08bb577eca7dbeefa99ef59d24afbf1f28f832786e" => :el_capitan
    sha256 "c3a8155c365566ea3e56c77a5f9118fd4cae5daea7fc2c88e692aa2c69b693b8" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/0c/ea/3581ba57d152fab6e3e928363d498848c7a50ab43b32bb81867bd803b9ba/paramiko-1.17.2.tar.gz"
    sha256 "d436971492bf11fb9807c08f41d4115a82bd592a844971737a6a8e8900c4677c"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
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

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"fabfile.py").write <<-EOS.undent
      from fabric.api import task, puts, env
      @task
      def hello():
        puts("fabric " + env.version)
    EOS
    expected = <<-EOS.undent
      fabric #{version}

      Done.
    EOS
    assert_equal expected, shell_output("#{bin}/fab hello")
  end
end
