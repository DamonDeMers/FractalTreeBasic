package com.abacus.core
{
	public class AbacusAssetsEmbed{
		
		[Embed(source="../../../assets/fonts/nevis.ttf", embedAsCFF="false", fontFamily="Nevis")]
		private static const Nevis:Class;
		
		[Embed(source="../../../assets/fonts/slimJoe.otf", embedAsCFF="false", fontFamily="SlimJoe")]
		private static const SLIM_JOE:Class;
	}
}