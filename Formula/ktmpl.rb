class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/InQuicker/ktmpl"
  url "https://github.com/InQuicker/ktmpl/archive/0.7.0.tar.gz"
  sha256 "c10d26f8e834543d8f0952a76b67292cd8f10f0814128cda9bb623ffe0952615"
  head "https://github.com/InQuicker/ktmpl.git"

  bottle do
    rebuild 1
    sha256 "45f56d5620d6fa8937eb4d6dbdf272393c7c1d6d21893fc8c08448f2e82855d6" => :high_sierra
    sha256 "2e93a2a0750d6893df927c450e776a563f43c66b04c48958987609b11ebc2a93" => :sierra
    sha256 "0cdef812428adbc54cf7d72dd492a96cda1dabf537d3461244cca627cf94f14d" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      kind: "Template"
      apiVersion: "v1"
      metadata:
        name: "test"
      objects:
        - kind: "Service"
          apiVersion: "v1"
          metdata:
            name: "test"
          spec:
            ports:
              - name: "test"
                protocol: "TCP"
                targetPort: "$((PORT))"
            selector:
              app: "test"
      parameters:
        - name: "PORT"
          description: "The port the service should run on"
          required: true
          parameterType: "int"
    EOS
    system bin/"ktmpl", "test.yml", "-p", "PORT", "8080"
  end
end
