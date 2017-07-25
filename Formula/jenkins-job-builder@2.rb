class JenkinsJobBuilderAT2 < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "http://ci.openstack.org/jjb.html"
  # https://pypi.python.org/pypi/jenkins-job-builder/2.0.0.0b2
  url "https://files.pythonhosted.org/packages/93/d3/c33e4dfae405c2c9bbe10a9dd1ffc2786f58902cd2834acef144aa9e506e/jenkins-job-builder-2.0.0.0b2.tar.gz"
  sha256 "5d0c93ec4454279e7fceea7e4b4416e7a2a782737bcad5930b892566b8a01ef8"

  bottle do
    cellar :any_skip_relocation
    sha256 "065dffac2378357c96f11f4d30d2fa9c60172bedef24057dcbb2cb50b493e965" => :sierra
    sha256 "d2ef10a5f53522c56636a1514311fc50a4953ffc97ec2cd8f48d903099c88be7" => :el_capitan
    sha256 "d2ef10a5f53522c56636a1514311fc50a4953ffc97ec2cd8f48d903099c88be7" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pyyaml" do
    url "http://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/09/1c/72bc7d3e1964633b29c9013813e3c0da0f6ae15c901ddc3863e2c54e87f7/python-jenkins-0.4.15.tar.gz"
    sha256 "12c50a027e12048504c71e984e8e776a15a1204065b86ca2d1d871802c6da336"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/08/58/e21f4691e8e75a290bdbfa366f06b9403c653642ef31f879e07f6f9ad7db/stevedore-1.25.0.tar.gz"
    sha256 "c8a373b90487b7a1b52ebaa3ca5059315bf68d9ebe15b2203c2fa675bd7e1e7e"
  end

  resource "multi_key_dict" do
    url "https://files.pythonhosted.org/packages/source/m/multi_key_dict/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pyyaml python-jenkins pbr six stevedore multi_key_dict].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match(/Managed by Jenkins Job Builder/,
                 pipe_output("#{bin}/jenkins-jobs test /dev/stdin",
                             "- job:\n    name: test-job\n\n", 0))
  end
end
