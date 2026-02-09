
'use client';

import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount, useReadContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
// 【修改点 1】引入 TOKEN_CONTRACT_ADDRESS
import { BANK_CONTRACT_ADDRESS, TOKEN_CONTRACT_ADDRESS } from '../constants';
import abi from '../constants/abi.json';
// 【修改点 2】引入代币 ABI
import tokenAbi from '../constants/tokenAbi.json';
import { formatEther, parseEther } from 'viem';
import { useEffect, useState } from 'react';

export default function Page() {
  const { address, isConnected } = useAccount();
  const [depositAmount, setDepositAmount] = useState('');
  const [withdrawAmount, setWithdrawAmount] = useState('');

  // 1. 读取 Bank 合约余额 (ETH)
  const { data: balance, refetch } = useReadContract({
    address: BANK_CONTRACT_ADDRESS,
    abi: abi,
    functionName: 'getMyBalance',
    account: address,
  });

  // 【修改点 3】新增：读取 Token 合约余额 (MOON)
  const { data: tokenBalance } = useReadContract({
    address: TOKEN_CONTRACT_ADDRESS,
    abi: tokenAbi,
    functionName: 'balanceOf', // ERC20 标准查询函数
    args: address ? [address] : undefined, // 查询当前连接钱包的余额
    account: address,
  });

  // 2. 写合约的钩子 (Bank 存款/取款)
  const { data: hash, writeContract, isPending } = useWriteContract();
  const { isSuccess: isConfirmed } = useWaitForTransactionReceipt({ hash });

  useEffect(() => {
    if (isConfirmed) {
      refetch(); // 交易成功后刷新 Bank 余额
      // 注意：Token 余额一般不需要这里手动刷新，wagmi 会自动处理，或者你可以加个 refetchToken
      setDepositAmount('');
      setWithdrawAmount('');
    }
  }, [isConfirmed, refetch]);

  // 3. 存款函数
  const handleDeposit = () => {
    if (!depositAmount) return;
    writeContract({
      address: BANK_CONTRACT_ADDRESS,
      abi: abi,
      functionName: 'deposit',
      value: parseEther(depositAmount),
    });
  };

  // 4. 取款函数
  const handleWithdraw = () => {
    if (!withdrawAmount) return;
    writeContract({
      address: BANK_CONTRACT_ADDRESS,
      abi: abi,
      functionName: 'withdraw',
      args: [parseEther(withdrawAmount)],
    });
  };

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '100vh', flexDirection: 'column', gap: '20px', background: '#f0f2f5', padding: '20px' }}>
      <h1>W-11K Bank & Token Dashboard</h1>
      <ConnectButton />

      {isConnected && (
        <div style={{ width: '100%', maxWidth: '400px', display: 'flex', flexDirection: 'column', gap: '20px' }}>
          
          {/* 【修改点 4】资产显示区域升级为多资产面板 */}
          <div style={{ background: 'white', padding: '20px', borderRadius: '15px', boxShadow: '0 4px 12px rgba(0,0,0,0.05)' }}>
            <h3 style={{ borderBottom: '1px solid #eee', paddingBottom: '10px', marginBottom: '15px', color: '#333' }}>
              我的资产包
            </h3>
            
            {/* Bank 余额行 */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
              <span style={{ color: '#666' }}>🏦 Bank 存款:</span>
              <span style={{ fontWeight: 'bold', fontSize: '18px' }}>
                {balance ? formatEther(balance as bigint) : '0'} ETH
              </span>
            </div>

            {/* Token 余额行 */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span style={{ color: '#0070f3' }}>🚀 MOON 余额:</span>
              <span style={{ fontWeight: 'bold', fontSize: '18px', color: '#0070f3' }}>
                {/* 这里会自动把 10^18 格式化为正常数字 */}
                {tokenBalance ? formatEther(tokenBalance as bigint) : '0'}
              </span>
            </div>
          </div>

          {/* 存款交互区 */}
          <div style={{ background: 'white', padding: '20px', borderRadius: '15px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
            <input 
              type="number" 
              placeholder="输入存款金额 (ETH)" 
              value={depositAmount}
              onChange={(e) => setDepositAmount(e.target.value)}
              style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }}
            />
            <button 
              onClick={handleDeposit}
              disabled={isPending || !depositAmount}
              style={{ padding: '12px', background: '#0070f3', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 'bold' }}
            >
              存入银行
            </button>
          </div>

          {/* 取款交互区 */}
          <div style={{ background: 'white', padding: '20px', borderRadius: '15px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
            <input 
              type="number" 
              placeholder="输入取款金额 (ETH)" 
              value={withdrawAmount}
              onChange={(e) => setWithdrawAmount(e.target.value)}
              style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }}
            />
            <button 
              onClick={handleWithdraw}
              disabled={isPending || !withdrawAmount}
              style={{ padding: '12px', background: '#ff4d4f', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 'bold' }}
            >
              从银行取出
            </button>
          </div>

          {isPending && <p style={{ textAlign: 'center', color: '#0070f3' }}>⏳ 正在处理区块链请求...</p>}
        </div>
      )}
    </div>
  );
}