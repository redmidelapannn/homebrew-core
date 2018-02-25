class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.3.0.tar.gz"
  sha256 "ffe2d74b5a0fbde84a96dfd39f1f899fc691e3585bf0d46ada976899038452e1"

  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2feede4c6c38560484d849cff07355da1235fb5442cfcf2b9ff876034e671e01" => :high_sierra
    sha256 "2feede4c6c38560484d849cff07355da1235fb5442cfcf2b9ff876034e671e01" => :sierra
    sha256 "2da3fd48a559081682e87523a86f0f0267a7279652dbaa427405364d22d9fd8d" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
