class BzrFastimport < Formula
  desc "Bazaar plugin for fast loading of revision control"
  homepage "https://launchpad.net/bzr-fastimport"
  url "https://launchpad.net/bzr-fastimport/trunk/0.13.0/+download/bzr-fastimport-0.13.0.tar.gz"
  sha256 "5e296dc4ff8e9bf1b6447e81fef41e1217656b43368ee4056a1f024221e009eb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a62ebdc803f3769937b126419ef377beb3e653587d9ace9bcde0489fb78d7c83" => :high_sierra
    sha256 "a62ebdc803f3769937b126419ef377beb3e653587d9ace9bcde0489fb78d7c83" => :sierra
    sha256 "a62ebdc803f3769937b126419ef377beb3e653587d9ace9bcde0489fb78d7c83" => :el_capitan
  end

  depends_on "python@2"
  depends_on "bazaar"

  resource "python-fastimport" do
    url "https://launchpad.net/python-fastimport/trunk/0.9.2/+download/python-fastimport-0.9.2.tar.gz"
    sha256 "fd60f1173e64a5da7c5d783f17402f795721b7548ea3a75e29c39d89a60f261e"
  end

  def install
    resource("python-fastimport").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    (share/"bazaar/plugins/fastimport").install Dir["*"]
  end

  def caveats; <<~EOS
    In order to use this plugin you must set your PYTHONPATH in your #{shell_profile}:

      export PYTHONPATH="#{opt_libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    bzr = Formula["bazaar"].bin/"bzr"
    system bzr, "init"
    assert_match(/fastimport #{version}/,
                 shell_output("#{bzr} plugins --verbose"))
    system bzr, "fast-export", "--plain", "."
  end
end
