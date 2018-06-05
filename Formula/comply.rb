class Comply < Formula
  desc "Compliance automation framework, focused on SOC2"
  homepage "https://comply.strongdm.com"
  url "https://github.com/strongdm/comply/archive/v1.2.3.tar.gz"
  sha256 "d818536eb1fe84a211399c6252a761babb29695c2036f69950fb6d74eeeb7d64"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4c6ae7d775bca367055c67f2526235033e068f2d4c913593b9a9b034dd53704" => :high_sierra
    sha256 "7fbef649f84ceb1654eb710a98dfd4ad3504143deae37f5c9c26315441a22c96" => :sierra
    sha256 "4e6e4c09b706997647b931bf54af842f66fb89cd07285d80cf17b0c36371be93" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    (buildpath/"src/github.com/strongdm/comply").install buildpath.children
    cd "src/github.com/strongdm/comply" do
      system "make", "brew"
      bin.install "bin/comply"
    end
  end

  test do
    (testpath/"init_comply.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout 2
      spawn #{bin}/comply init
      send -- "Hello Corporation\\r"
      expect "*Filename Prefix*"
      send -- "\\r\\r\\r"
      expect "*GitHub*"
      send -- "\\r"
      expect "*Configure github now*"
      send -- "\\r\\r"
      expect "+:+"
      send -- "thing\\r"
      expect "+:+"
      send -- "thing\\r"
      expect "+:+"
      send -- "thing\\r"
      expect "+:+"
      send -- "thing\\r"
      expect "*Next steps*"
      expect eof
    EOS

    chmod 0755, testpath/"init_comply.sh"
    mkdir testpath/"rundir"

    system "cd rundir && ../init_comply.sh"
    assert_predicate testpath/"rundir/narratives", :exist?
    assert_predicate testpath/"rundir/policies", :exist?
    assert_predicate testpath/"rundir/procedures", :exist?
    assert_predicate testpath/"rundir/standards", :exist?
    assert_predicate testpath/"rundir/templates", :exist?
  end
end
