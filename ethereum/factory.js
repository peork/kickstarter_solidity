import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
    '0x609Fa935a5B4478e274a3ec40dE7b660D2752F7c'
);

export default instance;