class Euca2ools < Formula
  desc "Eucalyptus client API tools-works with Amazon EC2 and IAM"
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://downloads.eucalyptus.com/software/euca2ools/3.3/source/euca2ools-3.3.1.tar.xz"
  sha256 "4440ea5df3a52ac7009eff7313fce7e2cc3f91cefc59adeacd7d991d5244090a"
  head "https://github.com/eucalyptus/euca2ools.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1018c7e1c50a31ea343d02bd160bbc4e1b8c41b0268a3183233fcbf600e2bfca" => :el_capitan
    sha256 "65a4fadc8d3e146c3099b388fc0ed8760fc20c83df4a88a84bf202022e1c312c" => :yosemite
    sha256 "1cfcd3706406c7a8417c51aa4b2217d0eae7ab1f4bd70ed4715692a2c5755393" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requestbuilder" do
    url "https://github.com/boto/requestbuilder/archive/v0.3.4.tar.gz"
    sha256 "f4fa8fab964b7ed94163d941c752e33dce3fd059f29618c9243808fd89a9aeb4"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz"
    sha256 "718d13adf87f99a45835bb20e0a1c4c036de644cd32b3f112639403aa04ebeb5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.2.tar.gz"
    sha256 "c7d5990298af6ffb00312973a25f0cc917a6368126dd40eaab41d78d3e1ea25d"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt",
           "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/euca-version"
    system "#{bin}/euca-describe-instances", "--help"
  end
end
