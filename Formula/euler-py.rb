class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.3.0.tar.gz"
  sha256 "ffe2d74b5a0fbde84a96dfd39f1f899fc691e3585bf0d46ada976899038452e1"

  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "11ea368ebf51816b4933e70894d13bc7a28d31551a8a5629217f7cc2f9d84a5a" => :high_sierra
    sha256 "11ea368ebf51816b4933e70894d13bc7a28d31551a8a5629217f7cc2f9d84a5a" => :sierra
    sha256 "11ea368ebf51816b4933e70894d13bc7a28d31551a8a5629217f7cc2f9d84a5a" => :el_capitan
  end

  depends_on "python@2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    resource("click").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}",
             "--single-version-externally-managed", "--record=installed.txt"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
           "--single-version-externally-managed", "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
