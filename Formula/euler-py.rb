class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.4.0.tar.gz"
  sha256 "0d2f633bc3985c8acfd62bc76ff3f19d0bfb2274f7873ec7e40c2caef315e46d"
  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c03f14e144087d62b881f96d8b3f13e8fab17c2b5ed55ffdb9823ac3bdbd6c1" => :catalina
    sha256 "2c03f14e144087d62b881f96d8b3f13e8fab17c2b5ed55ffdb9823ac3bdbd6c1" => :mojave
    sha256 "2c03f14e144087d62b881f96d8b3f13e8fab17c2b5ed55ffdb9823ac3bdbd6c1" => :high_sierra
  end

  depends_on "python@3.8"

  resource "click" do
    url "https://files.pythonhosted.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python#{xy}/site-packages"
    resource("click").stage do
      system "python3", "setup.py", "install", "--prefix=#{libexec}",
                        "--single-version-externally-managed",
                        "--record=installed.txt"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python#{xy}/site-packages"
    system "python3", "setup.py", "install", "--prefix=#{prefix}",
                      "--single-version-externally-managed",
                      "--record=installed.txt"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/euler") do |stdin, stdout, _|
      stdin.write("\n")
      stdin.close
      assert_match 'Successfully created "001.py".', stdout.read
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
