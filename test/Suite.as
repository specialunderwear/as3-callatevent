package
{	
	import cases.As3Assumptions;
	import cases.CallAtEventBindingTest;
	import cases.CallMethodAtEventFactoryTest;
	import cases.CallClosureAtEventFactoryTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Suite
	{
		public var as3Assumptions:As3Assumptions;
		public var callAtEventBindingTest:CallAtEventBindingTest;
		public var callMethodAtEventFactoryTest:CallMethodAtEventFactoryTest;
		public var callClosureAtEventFactoryTest:CallClosureAtEventFactoryTest;
	}
}