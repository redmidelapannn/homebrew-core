class Libgraphqlparser < Formula
  desc "GraphQL query parser in C++ with C and C++ APIs"
  homepage "https://github.com/graphql/libgraphqlparser"
  url "https://github.com/graphql/libgraphqlparser/archive/0.7.0.tar.gz"
  sha256 "63dae018f970dc2bdce431cbafbfa0bd3e6b10bba078bb997a3c1a40894aa35c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "268334d28d6864b82ff126d45ea8c0655d49eb7c1d672267c1bb58b456722de4" => :catalina
    sha256 "497fcbfbbbab35766a9e071737a0dd727d6c2df7def172cd6da84c5678affc6b" => :mojave
    sha256 "311e275b406c67f95c22e056bad67e6de09bf4760f1f51ff775ed4d31d6ff9ee" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :macos # Due to Python 2

  def install
    system "cmake", ".", "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                         *std_cmake_args
    system "make"
    system "make", "install"
    libexec.install "dump_json_ast"
  end

  test do
    sample_query = <<~EOS
      { user }
    EOS

    # A nightmare to get these lines shorter.
    # rubocop:disable Layout/LineLength
    sample_ast = { "kind"        => "Document",
                   "loc"         => { "start" => { "line"=>1, "column"=>1 },
                                      "end"   => { "line"=>1, "column"=>9 } },
                   "definitions" =>
                                    [{ "kind"                => "OperationDefinition",
                                       "loc"                 => { "start" => { "line"=>1, "column"=>1 },
                                                                  "end"   => { "line"=>1, "column"=>9 } },
                                       "operation"           => "query",
                                       "name"                => nil,
                                       "variableDefinitions" => nil,
                                       "directives"          => nil,
                                       "selectionSet"        =>
                                                                { "kind"       => "SelectionSet",
                                                                  "loc"        => { "start" => { "line"=>1, "column"=>1 },
                                                                                    "end"   => { "line"=>1, "column"=>9 } },
                                                                  "selections" =>
                                                                                  [{ "kind"         => "Field",
                                                                                     "loc"          => { "start" => { "line"=>1, "column"=>3 },
                                                                                                         "end"   => { "line"=>1, "column"=>7 } },
                                                                                     "alias"        => nil,
                                                                                     "name"         =>
                                                                                                       { "kind"  => "Name",
                                                                                                         "loc"   => { "start" => { "line"=>1, "column"=>3 },
                                                                                                                      "end"   => { "line"=>1, "column"=>7 } },
                                                                                                         "value" => "user" },
                                                                                     "arguments"    => nil,
                                                                                     "directives"   => nil,
                                                                                     "selectionSet" => nil }] } }] }

    # rubocop:enable Layout/LineLength
    test_ast = JSON.parse pipe_output("#{libexec}/dump_json_ast", sample_query)
    assert_equal sample_ast, test_ast
  end
end
