class Glances < Formula
  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://github.com/nicolargo/glances/archive/v3.0.tar.gz"
  sha256 "7428ed7c598b5d9ee464dd20c06f58df62e398fe7daf6596933a656f72bee1ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "e201b15e5c407a9e20f2fc77c0f750754e7b3420ae8d762ac8a73a32ff63216d" => :mojave
    sha256 "9bfbdd87e8965ff20c8393351f349dab9243c897c69d0415951c58560fa5c3aa" => :high_sierra
    sha256 "c14791818db32ce671016f58759651301566759104724745c643e1303555ea64" => :sierra
    sha256 "bf244898ed45be0d02fcb1cc9af8fb224bda53d03393722d6ccfd1fab94d9673" => :el_capitan
  end

  depends_on "python@2"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/7d/9a/1e93d41708f8ed2b564395edfa3389f0fd6d567597401c2e5e2775118d8b/psutil-5.4.7.tar.gz"
    sha256 "5b6322b167a5ba0c5463b4d30dfd379cd4ce245a1162ebf8fc7ab5c5ffae4f3b"
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
