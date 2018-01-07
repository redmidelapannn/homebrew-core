class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v2.11.1.tar.gz"
  sha256 "446a0ee6e13c0c7ceb4bc0d4868add8a02d5e3ff866de8e880bdb33dce6ab3fc"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e2/e1/600326635f97fee89bf8426fef14c5c29f4849c79f68fd79f433d8c1bd96/psutil-5.4.3.tar.gz"
    sha256 "e2467e9312c2fa191687b89ff4bc2ad8843be4af6fb4dc95a7cc5f7d7a327b18"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    begin
      read, write = IO.pipe
      pid = fork do
        exec bin/"glances", "-q", "--export-csv", "/dev/stdout", :out => write
      end
      header = read.gets
      assert_match(/timestamp/, header)
    ensure
      Process.kill(:TERM, pid)
    end
  end
end
