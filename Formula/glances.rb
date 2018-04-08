class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v2.11.1.tar.gz"
  sha256 "446a0ee6e13c0c7ceb4bc0d4868add8a02d5e3ff866de8e880bdb33dce6ab3fc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3d3a7c1c2ea225d8cd39663ed7cd6db1171014f69fbb73acd9ed15d0627f8c1f" => :high_sierra
    sha256 "aabd77720d4d095ec55a70a84047376101f26d5e50e052482ce13dcaf04fb24e" => :sierra
    sha256 "bf31a240f21ac4101eb4d836659928a8383acbce2516ed44e82379d60402d7ba" => :el_capitan
  end

  depends_on "python@2"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e2/e1/600326635f97fee89bf8426fef14c5c29f4849c79f68fd79f433d8c1bd96/psutil-5.4.3.tar.gz"
    sha256 "e2467e9312c2fa191687b89ff4bc2ad8843be4af6fb4dc95a7cc5f7d7a327b18"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("psutil").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    prefix.install libexec/"share"
  end

  test do
    begin
      read, write = IO.pipe
      pid = fork do
        exec bin/"glances", "-q", "--export-csv", "/dev/stdout", :out => write
      end
      header = read.gets
      assert_match "timestamp", header
    ensure
      Process.kill("TERM", pid)
    end
  end
end
