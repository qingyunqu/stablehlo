module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xui8>, tensor<1xui8>)
    %2 = call @expected() : () -> tensor<1x125xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {indices_are_sorted = false, scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xui8>, tensor<1xi32>, tensor<1xui8>) -> tensor<1x125xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xui8>, tensor<1x125xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xui8>, tensor<1xui8>) {
    %0 = stablehlo.constant dense<"0x0209020100030003010301020002010403000100010004000704040100010300030001010300010102030004020001020001000201000202010002000200040105030001020702020100040101010003010201000103020102030601040001010401030200010402060303000801000003020002010002030300020205"> : tensor<1x125xui8>
    %1 = stablehlo.constant dense<5> : tensor<1xui8>
    return %0, %1 : tensor<1x125xui8>, tensor<1xui8>
  }
  func.func private @expected() -> tensor<1x125xui8> {
    %0 = stablehlo.constant dense<"0x0509020100030003010301020002010403000100010004000704040100010300030001010300010102030004020001020001000201000202010002000200040105030001020702020100040101010003010201000103020102030601040001010401030200010402060303000801000003020002010002030300020205"> : tensor<1x125xui8>
    return %0 : tensor<1x125xui8>
  }
}