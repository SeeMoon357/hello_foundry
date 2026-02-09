import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { sepolia } from 'wagmi/chains';

export const config = getDefaultConfig({
  appName: 'W-11K Bank DApp',
  projectId: '04309ed1007e49d03599739530355613', // 这是一个公共测试 ID，可以直接用
  chains: [sepolia], // 我们只连 Sepolia
  ssr: true,
});